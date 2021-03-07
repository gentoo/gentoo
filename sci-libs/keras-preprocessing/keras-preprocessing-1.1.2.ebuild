# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
MY_PN="Keras_Preprocessing"

DESCRIPTION="Easy data preprocessing and data augmentation for deep learning models"
HOMEPAGE="https://keras.io/"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN::1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
