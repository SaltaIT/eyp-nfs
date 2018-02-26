require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'nfs class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'nfs':
        is_server => true,
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it 'should work with no errors' do
      pp = <<-EOF

      class { 'nfs':
        is_server => true,
      }

      nfs::export { '/etc':
        fsid => '1',
      }

      ->

      nfs::nfsmount { '/mnt/etc':
        nfsdevice => '127.0.0.1:/etc',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/exports") do
      it { should be_file }
      its(:content) { should match 'puppet managed file' }
      its(:content) { should match '/etc' }
    end

    it "mounts" do
      expect(shell("mount").exit_code).to be_zero
    end

    #showmount -e 127.0.0.1 | grep /etc
    it "showmount" do
      expect(shell("showmount -e 127.0.0.1 | grep /etc").exit_code).to be_zero
    end

    describe service($nfsservice) do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

  end
end
