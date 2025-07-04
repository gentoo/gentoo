# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="enhanced dd with features for forensics and security"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/dcfldd"
SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

DEPEND="virtual/pkgconfig"

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	ChangeLog
	NEWS
	README.md
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-bash-completion
}

src_test() {
	# Just in case upstream add tests in future
	default

	# Smoke test for Gentoo bug #930996
	# Inspired by https://gcc.gnu.org/bugzilla/show_bug.cgi?id=114698#c0
	expected_sha256sum="$(sha256sum <<<TestInput | awk '{print $1}')"
	actual_sha256sum="$(src/dcfldd hash=sha256 2>&1 <<<TestInput \
		| grep -F sha256 | awk '{print $3}')"
	[[ ${actual_sha256sum} = ${expected_sha256sum} ]] \
		|| die "dcfldd produced \"${actual_sha256sum}\" instead of expected \"${expected_sha256sum}\"."
}
