# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIKAGE
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="
	>=dev-libs/openssl-0.9.9:=
"
DEPEND=">=dev-libs/openssl-0.9.9:="
BDEPEND="
	${RDEPEND}
	dev-perl/ExtUtils-PkgConfig
	dev-perl/ExtUtils-CChecker
	test? (
		dev-perl/Test-Exception
		!minimal? (
			>=dev-perl/Test-Taint-1.60.0
			>=dev-perl/Taint-Util-0.80.0
		)
	)
"

PERL_RM_FILES=(
	t/boilerplate.t
	t/manifest.t
	t/pod-coverage.t
	t/pod.t
)
