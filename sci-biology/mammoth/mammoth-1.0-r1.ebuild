# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mammoth/mammoth-1.0-r1.ebuild,v 1.1 2015/03/05 11:07:15 jlec Exp $

EAPI=5

inherit autotools eutils fortran-2 flag-o-matic toolchain-funcs

MY_P="${P}-src"

DESCRIPTION="MAtching Molecular Models Obtained from THeory"
HOMEPAGE="http://ub.cbm.uam.es/software.php"
SRC_URI="${MY_P}.tgz"

LICENSE="mammoth"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

S=${WORKDIR}/${MY_P}

pkg_nofetch() {
	einfo "Download the source code for MAMMOTH from"
	einfo "${HOMEPAGE}"
	einfo "and place it in ${DISTDIR}"
}

src_prepare() {
	# Broken with gfortran without this patch
	epatch "${FILESDIR}"/${PV}-consistent-system-intrinsic.patch

	case $(tc-getFC) in
		g77)		append-fflags -ffixed-line-length-none ;;
		gfortran)	append-fflags -ffixed-line-length-none ;;
	esac

	# It comes with a custom-modified configure for some reason,
	# which forces you to pass in the Fortran compiler as a parameter.
	# Let's do the standard stuff instead.
	eautoreconf
}
