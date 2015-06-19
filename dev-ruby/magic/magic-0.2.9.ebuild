# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/magic/magic-0.2.9.ebuild,v 1.2 2015/05/28 05:13:40 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

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
ruby_add_rdepend "virtual/ruby-ffi"

each_ruby_test() {
	${RUBY} -Ilib -Itest test/test_magic.rb || die
}
