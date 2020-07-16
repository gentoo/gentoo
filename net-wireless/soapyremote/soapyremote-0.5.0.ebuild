# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit cmake-utils

DESCRIPTION="Soapy SDR remote module"
HOMEPAGE="https://github.com/pothosware/SoapyRemote"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/pothosware/SoapyRemote.git"
	EGIT_CLONE_TYPE="shallow"
	KEYWORDS=""
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pothosware/SoapyRemote/archive/soapy-remote-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/SoapyRemote-soapy-remote-"${PV}"
fi

LICENSE="Boost-1.0"
SLOT="0"

IUSE=""
REQUIRED_USE=""

RDEPEND="net-wireless/soapysdr
		net-dns/avahi"
DEPEND="${RDEPEND}"
