# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit eapi9-ver perl-module

DESCRIPTION="Client for Wake-On-LAN"
HOMEPAGE="https://github.com/jpoliv/wakeonlan/"
SRC_URI="https://github.com/jpoliv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.46"

src_prepare() {
	# would require Test::Spelling for which we have no ebuild
	rm "${S}"/t/93_pod_spell.t || die
	# the following ones are "only" lint, for which we have ebuilds
	# but not for all arches this ebuild has
	rm "${S}"/t/81_perlcritic.t || die # dev-perl/Test-Perl-Critic
	rm "${S}"/t/91_pod.t || die # dev-perl/Test-Pod
	rm "${S}"/t/92_pod_coverage.t || die # dev-perl/Test-Pod-Coverage

	perl-module_src_prepare
}

src_install() {
	perl-module_src_install
	dodoc examples/lab001.wol
	fperms u+w /usr/bin/wakeonlan /usr/share/man/man1/wakeonlan.1
}

pkg_postinst() {
	if ver_replacing -lt "0.42"; then
		ewarn "Gentoo used to have support for using hostnames from /etc/ethers"
		ewarn "versions >=0.42 do not carry that downstream patch/feature anymore"
		ewarn "you could wrap with i.e. \"getent ethers <hostname>\""
	fi
}
