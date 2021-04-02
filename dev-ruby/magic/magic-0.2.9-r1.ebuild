# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

SRC_URI="https://github.com/qoobaa/magic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Ruby FFI bindings to libmagic"
HOMEPAGE="https://github.com/qoobaa/magic"

IUSE="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="sys-apps/file"
DEPEND+="test? ( sys-apps/file )"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend "dev-ruby/ffi"

each_ruby_test() {
	${RUBY} -Ilib -Itest test/test_magic.rb || die
}
