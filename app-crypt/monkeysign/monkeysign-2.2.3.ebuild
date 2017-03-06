# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="A user-friendly commandline tool to sign OpenGPG keys"
HOMEPAGE="http://web.monkeysphere.info/monkeysign/"

SRC_URI="mirror://debian/pool/main/m/monkeysign/monkeysign_${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	media-gfx/zbar:0[python,gtk,imagemagick,${PYTHON_USEDEP}]
	media-gfx/qrencode-python[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	app-arch/xz-utils
	${CDEPEND}"

RDEPEND="
	app-crypt/gnupg
	virtual/mta
	${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-basename.patch"
	)

src_prepare() {
	sed -i "s/'rst2s5/'rst2s5.py/g" monkeysign/documentation.py || die
	sed -i "s/'--list-dirs'/'--dry-run --list-dirs'/" monkeysign/gpg.py || die
	rm CHANGELOG || die
	eapply_user
}

src_compile() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
	distutils-r1_src_compile
}

python_install_all() {
	distutils-r1_python_install_all
	domenu "${FILESDIR}/monkeysign.desktop"
}
