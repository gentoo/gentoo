# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="Pure Ruby implementation of the SMB Protocol Family"
HOMEPAGE="https://github.com/rapid7/ruby_smb"
SRC_URI="https://github.com/rapid7/ruby_smb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend "
	dev-ruby/bindata:*
	dev-ruby/rubyntlm
	dev-ruby/windows_error
"

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
		${PN}.gemspec || die

	sed -i \
		-e '/pry-byebug/d' \
		-e '/pry-rescue/d' \
		-e '/coveralls/d' \
		Gemfile || die
}
