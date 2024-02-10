# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRADFITZ
DIST_VERSION=0.94
inherit perl-module

DESCRIPTION="Asynchronous client module for Gearman for Danga::Socket applications"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/Gearman-1.70.0
	>=dev-perl/Danga-Socket-1.570.0
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/Gearman-Server )
"

DIST_TEST="do"

src_test() {
	local BADTESTS=(
		# blocks forever
		t/err1.t
		# https://rt.cpan.org/Public/Bug/Display.html?id=87063
		t/err3.t
	)
	perl_rm_files "${BADTESTS[@]}"
	perl-module_src_test
}
