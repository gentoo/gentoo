# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python interface for a malware identification and classification tool"
HOMEPAGE="https://github.com/VirusTotal/yara-python"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/VirusTotal/yara-python.git"
else
	SRC_URI="https://github.com/virustotal/yara-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	=app-forensics/yara-$(ver_cut 1-2)*
"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

python_configure_all() {
	cat >> setup.cfg <<-EOF
	[build_ext]
	dynamic_linking = True
	EOF
}

python_test() {
	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
