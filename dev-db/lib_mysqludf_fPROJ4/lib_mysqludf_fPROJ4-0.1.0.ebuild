# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="MySQL UDFs which converts geographic/cartesian coordinates"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_fPROJ4/"
SRC_URI="http://www.mysqludf.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/mysql-5.1
	sci-libs/proj"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

# compile helper
_compile() {
	local CC="$(tc-getCC)"
	echo "${CC} ${@}" && "${CC}" "${@}"
}

pkg_setup() {
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-warnings.patch"

	# fix doc (BOM, CR/LF, soname)
	sed -i -e '1 s|^\xEF\xBB\xBF||' \
		-e "s|'\(${PN}\).*'|'\1.so'|g" ${PN}.sql
	echo >> ${PN}.sql  # add LF
	edos2unix ${PN}.sql
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} -lproj \
		-shared ${LDFLAGS} -o ${PN}.so ${PN}.c
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe ${PN}.so
	dodoc ${PN}.sql
}

pkg_postinst() {
	elog
	elog "Please have a look at the documentation, how to"
	elog "enable/disable the UDF functions of ${PN}."
	elog
	elog "The documentation is located here:"
	elog "/usr/share/doc/${PF}"
	elog
}
