# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="A utility to see if a specific IP is taken and what MAC owns it"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=arping"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ThomasHabets/arping"
	inherit git-r3
else
	SRC_URI="https://github.com/ThomasHabets/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="GPL-2"
SLOT="2"
IUSE="+seccomp test"
RESTRICT="!test? ( test )"

RDEPEND="net-libs/libpcap
	net-libs/libnet:1.1
	sys-libs/libcap
	seccomp? ( sys-libs/libseccomp )
	!net-misc/iputils[arping(+)]"
DEPEND="${RDEPEND}
	test? (
		dev-libs/check
		dev-python/subunit
	)"

FILECAPS=( cap_net_raw usr/sbin/arping )

PATCHES=(
	"${FILESDIR}"/${PN}-2.23-configure.ac-seccomp-disable.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# Controls whether seccomp is used by default
		$(use_enable seccomp)
	)

	# Needed to actually make it optional and not automagic
	# (and we want it optional for the non-seccomp arches, like sparc)
	export ac_cv_lib_seccomp_seccomp_init=$(usex seccomp)
	export ac_cv_header_seccomp_h=$(usex seccomp)

	econf "${myeconfargs[@]}"
}
