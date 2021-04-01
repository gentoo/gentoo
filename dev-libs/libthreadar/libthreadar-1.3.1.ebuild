# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Threading library used by dar archiver"
HOMEPAGE="https://sourceforge.net/projects/libthreadar/"
SRC_URI="mirror://sourceforge/libthreadar/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure() {
	# Copy this comment from app-backup/dar as it applies here too
	#
	# configure.ac is totally funked up regarding the AC_ARG_ENABLE
	# logic.
	# For example "--enable-dar-static" causes configure to DISABLE
	# static builds of dar.
	# Do _not_ use $(use_enable) until you have verified that the
	# logic has been fixed by upstream.

	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
