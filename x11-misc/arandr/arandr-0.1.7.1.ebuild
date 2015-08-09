# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="A simple visual frontend for XRandR 1.2/1.3"
HOMEPAGE="http://christian.amsuess.com/tools/arandr/"
SRC_URI="http://christian.amsuess.com/tools/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2[${PYTHON_USEDEP}]
	x11-apps/xrandr"
DEPEND=">=dev-python/docutils-0.6[${PYTHON_USEDEP}]"

src_prepare() {
	local i p
	# simulate gettext behavior:
	#  LINGUAS unset => install all
	#  LINGUAS="" => install none
	#  LINGUAS="de fr" => install de and fr
	if [[ -n "${LINGUAS+x}" ]] ; then # if LINGUAS is set
		for i in $(cd "${S}"/data/po ; for p in *.po ; do echo ${p%.po} ; done) ; do # for every supported language
			if ! has ${i} ${LINGUAS} ; then # if language is disabled
				rm data/po/${i}.po || die
			fi
		done
	fi
	distutils-r1_src_prepare
}
