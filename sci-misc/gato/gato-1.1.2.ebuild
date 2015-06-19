# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/gato/gato-1.1.2.ebuild,v 1.2 2012/09/16 16:07:37 jlec Exp $

EAPI=4

PYTHON_DEPEND="2"
PYTHON_USE_WITH="tk"

inherit eutils python

MYP="Gato-${PV}"

DESCRIPTION="Graph Animation Toolbox"
HOMEPAGE="http://gato.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MYP}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# change TKinter call to avoid crashing of X
	sed -i \
		-e 's:self.overrideredirect(1):self.overrideredirect(0):' \
		"${S}"/GatoDialogs.py || die "failed to patch GatoDialogs.py"
}

src_install() {
	# install python code
	local instdir=$(python_get_sitedir)/${PN}
	insinto ${instdir}
	doins *.py
	fperms 755 ${instdir}/{Gato,Gred}.py
	python_convert_shebangs -r 2 "${ED}"

	# create symlinks
	dosym ${instdir}/Gato.py /usr/bin/gato
	dosym ${instdir}/Gred.py /usr/bin/gred

	# install data files
	insinto /usr/share/${PN}
	doins BFS.* DFS.* sample.cat
}
