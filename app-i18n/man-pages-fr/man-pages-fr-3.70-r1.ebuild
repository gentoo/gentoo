# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV}-1"
DESCRIPTION="A somewhat comprehensive collection of French Linux man pages"
HOMEPAGE="https://traduc.org/perkamon"

SRC_URI="
	https://gitlab.com/perkamon/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${PN}-${MY_PV}-${PR}.tar.gz
	https://gitlab.com/perkamon/man-pages/-/archive/${PV}/man-pages-${PV}.tar.gz -> perkamon-man-pages-${PV}.tar.gz
	https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/Archive/man-pages-${PV}.tar.xz
"

LICENSE="BSD GPL-2+ man-pages"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="app-text/po4a"

RDEPEND="virtual/man"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${PF}-fix-unpack.patch"
)

src_unpack() {
	unpack "${PN}-${MY_PV}-${PR}.tar.gz"

	cd "${S}" || die
	unpack "perkamon-man-pages-${PV}.tar.gz"
	mv "man-pages-${PV}" "perkamon" || die

	cd "perkamon" || die
	unpack "man-pages-${PV}.tar.xz"
	mv "man-pages-${PV}" "man-pages" || die
}

src_compile() {
	emake translate
}

src_install() {
	einstalldocs

	doman -i18n=fr build/fr/man*/*
}
