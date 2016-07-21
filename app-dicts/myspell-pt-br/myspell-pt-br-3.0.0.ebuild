# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MYSPELL_DICT=(
	"pt_BR.aff"
	"pt_BR.dic"
)

MYSPELL_HYPH=(
	"hyph_pt_BR.dic"
)

MYSPELL_THES=(
	"th_pt_BR.dat"
	"th_pt_BR.idx"
)

inherit myspell-r2

DESCRIPTION="Brazilian dictionaries for myspell/hunspell"
HOMEPAGE="http://pt-br.libreoffice.org/projetos/projeto-vero-verificador-ortografico/"
SRC_URI="
	http://pt-br.libreoffice.org/assets/VeroptBRV${PV//./}AOG.oxt
	http://wiki.documentfoundation.org/images/f/ff/DicSin-BR.oxt -> ${P}-thes.oxt
"

LICENSE="LGPL-3 MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
