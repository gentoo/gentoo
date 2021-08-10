# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"
inherit desktop ruby-ng

DESCRIPTION="Map editor for the game gnocatan"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${PN}-$(ver_rs 1- _).tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend dev-ruby/ruby-gtk2

PATCHES=(
	"${FILESDIR}"/${P}-implicit-string.patch
)

all_ruby_prepare() {
	# this is really single target, but ruby-single is too limited
	local ruby=$(ruby_get_use_implementations)
	sed -i "1c\\#!$(ruby_implementation_command ${ruby##* })" ${PN} || die

	rm Makefile || die
}

all_ruby_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r *.rb img

	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Camato
}
