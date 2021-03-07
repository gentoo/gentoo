# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}_${PV}"

DESCRIPTION="Fuse multi harddrive filesystem"
HOMEPAGE="http://mhddfs.uvw.ru/ http://svn.uvw.ru/mhddfs/trunk/README"
SRC_URI="http://mhddfs.uvw.ru/downloads/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

IUSE="l10n_ru suid"

RDEPEND="
	dev-libs/glib:2
	sys-fs/fuse:0
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )
PATCHES=(
	"${FILESDIR}/${PN}-respect-compiler-vars.patch"
	"${FILESDIR}/${P}-segfault-fix.patch"
	"${FILESDIR}/${P}-xattr.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin mhddfs
	doman mhddfs.1
	einstalldocs
	use l10n_ru && dodoc README.ru.UTF-8
	use suid && fperms u+s /usr/bin/${PN}
}

pkg_postinst() {
	if use suid; then
		ewarn
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
		ewarn
	fi
}
