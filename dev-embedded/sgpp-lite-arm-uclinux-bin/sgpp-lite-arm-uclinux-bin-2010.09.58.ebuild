# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

CPU="arm"
TARGET="arm-uclinuxeabi"
HOST="i686-pc-linux-gnu"
MY_P="${CPU}-${PV%.*}-${PV##*.}-${TARGET}-${HOST}"

DESCRIPTION="regular, validated releases of the GNU Toolchain for ${CPU} processors by CodeSourcery"
HOMEPAGE="http://www.codesourcery.com/sgpp/lite/${CPU}"
SRC_URI="http://www.codesourcery.com/public/gnu_toolchain/${TARGET}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="strip" # package is already stripped, and contains target bins
QA_EXECSTACK="opt/${P}/*"

RDEPEND="sys-libs/glibc"
DEPEND=""

S=${WORKDIR}/${CPU}-${PV%.*}

src_install() {
	local d="/opt/${P}"
	dodir ${d}
	cp -pPR * "${D}"/${d}/ || die

	pushd "${D}"/${d}/share/doc/${CPU}-${TARGET} >/dev/null
	if use doc ; then
		dohtml -r html/* || die
		dodoc pdf/* || die
	fi
	rm -rf html pdf
	rm LICENSE.txt man/man7/{fsf-funding,gpl,gfdl}.7 || die
	mv man info ../..
	popd >/dev/null
	find "${D}" -depth -type d -empty -delete

	cat <<-EOF > "${T}"/15${P}
	PATH=${d}/bin
	MANPATH=${d}/share/man
	INFOPATH=${d}/share/info
	EOF
	doenvd "${T}"/15${P} || die
}
