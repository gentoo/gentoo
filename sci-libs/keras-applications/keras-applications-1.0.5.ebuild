# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Keras deep learning library reference implementations of deep learning models"
HOMEPAGE="https://keras.io/applications/"
SRC_URI="https://files.pythonhosted.org/packages/60/27/a25dfc6e49a6ab3de2d5f23fdb851f18d45ea9867a0955906a5c488ebbe2/Keras_Applications-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/Keras_Applications-${PV}/"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
