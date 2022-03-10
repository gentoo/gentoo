# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python interface for a malware identification and classification tool"
HOMEPAGE="https://github.com/VirusTotal/yara-python"
SRC_URI="https://github.com/virustotal/yara-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	=app-forensics/yara-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}"

distutils_enable_tests unittest

src_compile() {
	compile_python() {
		distutils-r1_python_compile --dynamic-linking
	}
	python_foreach_impl compile_python
}

python_test() {
	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
