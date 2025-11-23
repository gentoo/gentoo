# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Soapy SDR plugin for SDRPlay"
HOMEPAGE="https://github.com/pothosware/SoapySDRPlay3"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapySDRPlay3.git"
	EGIT_CLONE_TYPE="shallow"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	COMMIT_HASH="b789d5985b900973c81c69aa04cb3c7ebe620a75"
	SRC_URI="https://github.com/pothosware/SoapySDRPlay/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapySDRPlay3-"${COMMIT_HASH}"
fi

LICENSE="Boost-1.0"
SLOT="0"

IUSE=""
REQUIRED_USE=""

RDEPEND="net-wireless/soapysdr
	>=net-wireless/sdrplay-3.07"
DEPEND="${RDEPEND}"
