# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby implementation of the SMB Protocol Family"
HOMEPAGE="https://github.com/rapid7/ruby_smb"
SRC_URI="https://github.com/rapid7/ruby_smb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend "
	~dev-ruby/bindata-2.4.15
	dev-ruby/openssl-ccm
	dev-ruby/openssl-cmac
	>=dev-ruby/rubyntlm-0.6.5
	>=dev-ruby/windows_error-0.1.4
"

ruby_add_depend "test? ( dev-ruby/rspec )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.5-import-pathname-no-simplecov.patch
)

all_ruby_prepare() {
	sed -i \
		-e '/simplecov/Id' \
		-e '/coveralls/d' \
		-e '/TRAVIS/d' \
		-e '1irequire "rubyntlm"; require "time"' \
		spec/spec_helper.rb || die

	sed -i \
		-e '/fivemat/d' \
		-e 's/git ls-files -z/find * -print0/' \
		${PN}.gemspec || die

	sed -i \
		-e '/pry-byebug/d' \
		-e '/pry-rescue/d' \
		-e '/coveralls/d' \
		Gemfile || die

	sed -i \
		-e 's/documentation/progress/' \
		.rspec || die

	# Avoid specs thar require obsolete ciphers
	sed -e '/Encrypts a hash/ s/it/xit/' \
		-i spec/lib/ruby_smb/dcerpc/samr/encrypted_nt_owf_password_spec.rb || die
	sed -e '/Encrypts correctly/ s/it/xit/' \
		-i spec/lib/ruby_smb/dcerpc/samr/sampr_encrypted_user_password_spec.rb || die
	sed -e '/\(decrypt_attribute_value\|remove_des_layer\)/ s/describe/xdescribe/' \
		-i spec/lib/ruby_smb/dcerpc/drsr_spec.rb || die
}
