# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ROCm System Management Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"

if [[ ${PV} == *9999 ]] ; then
	KEYWORDS="**"
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROC-smi"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROC-smi/archive/rocm-${PV}.tar.gz -> rocm-smi-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROC-smi-rocm-${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime
	 =dev-lang/python-3*"

src_compile() {
	einfo "Nothing todo"
}

src_install() {
	exeinto "/usr/bin"
	doexe "${S}/rocm_smi.py"
	dosym "./rocm_smi.py" "/usr/bin/rocm-smi"
}
