# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk(+)"

inherit distutils-r1

DESCRIPTION="Graph Animation Toolbox"
HOMEPAGE="http://gato.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P^}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${P^}"

python_prepare_all() {
	# change TKinter call to avoid crashing of X
	sed -i \
		-e 's:self.overrideredirect(1):self.overrideredirect(0):' \
		"${S}"/GatoDialogs.py || die "failed to patch GatoDialogs.py"

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# install data files
	insinto /usr/share/${PN}
	doins BFS.* DFS.* sample.cat
}
