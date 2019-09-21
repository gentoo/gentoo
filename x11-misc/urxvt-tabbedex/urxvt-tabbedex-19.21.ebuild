# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An extended version of rxvt-unicode's tabbed perl extension"
HOMEPAGE="https://github.com/mina86/urxvt-tabbedex"

MY_PN=${PN/urxvt-/}
SRC_URI="https://github.com/mina86/urxvt-tabbedex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=x11-terms/rxvt-unicode-9.21[perl]"

DOCS=( AUTHORS README.md command-runner.sample )

src_compile() { :; }

src_install() {
	einstalldocs

	insinto /usr/$(get_libdir)/urxvt/perl/
	doins ${MY_PN}

	insinto /usr/$(get_libdir)/urxvt/
	newins pgid-cd.pl tabbedex-pgid-cd
}
