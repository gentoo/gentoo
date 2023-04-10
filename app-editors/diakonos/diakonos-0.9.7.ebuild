# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30 ruby31"

inherit ruby-ng

DESCRIPTION="A Linux editor for the masses"
HOMEPAGE="https://git.sr.ht/~pistos/diakonos"
SRC_URI="https://github.com/Pistos/diakonos/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc test"

ruby_add_rdepend "dev-ruby/curses"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/rspec )"

each_ruby_test() {
	${RUBY} -S rspec -Ilib spec/*.rb spec/*/*.rb || die
}

each_ruby_install() {
	${RUBY} install.rb --dest-dir "${D}" --doc-dir /usr/share/doc/${PF} || die "install failed"
}

all_ruby_install() {
	if use doc; then
		rake docs || die
		dodoc -r doc/*
	fi
}
