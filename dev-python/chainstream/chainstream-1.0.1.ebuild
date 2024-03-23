# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Chain I/O-Streams together into a single stream"
HOMEPAGE="https://github.com/rrthomas/chainstream"
SRC_URI="https://github.com/rrthomas/chainstream/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

src_configure() {
	# upstream doesn't provide build system in pyproject.toml
	cat >> pyproject.toml <<-EOF || die
		[build-system]
		requires = ["setuptools", "wheel"]
		build-backend = "setuptools.build_meta"
	EOF
}
