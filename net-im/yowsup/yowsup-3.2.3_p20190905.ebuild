# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="bdepend"
EGIT_COMMIT="2adc067f306d9e7d8b634f66e96c52d80a42e1ff"
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
PYTHON_REQ_USE="readline"

inherit distutils-r1

DESCRIPTION="A library that enables you to build applications which use the WhatsApp service"
HOMEPAGE="https://github.com/tgalal/yowsup"
SRC_URI="https://github.com/tgalal/yowsup/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	dev-python/consonance[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-axolotl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

PATCHES=( "${FILESDIR}/${PF}-fix-install-path.patch" )

src_prepare() {
	default

	# After talking to upstream, version restriction can be lifted
	# and also 'argparse' needs to be removed.
	sed -e 's/==0.1.3-1//' -e 's/==0.2.2//' -e 's/==1.10//' -e 's/argparse//' -i setup.py || die
}

pkg_postinst() {
	einfo "Warning: It seems that recently yowsup gets detected during registration"
	einfo "resulting in an instant ban for your number right after registering"
	einfo "with the code you receive by sms/voice."
	einfo "See https://github.com/tgalal/yowsup/issues/2829 for more information."
}
