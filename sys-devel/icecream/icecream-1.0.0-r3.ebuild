# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/icecream/icecc}"

DESCRIPTION="Distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="https://github.com/icecc/icecream"
SRC_URI="ftp://ftp.suse.com/pub/projects/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"

DEPEND="sys-libs/libcap-ng"
RDEPEND="
	${DEPEND}
	acct-group/icecream
	acct-user/icecream
	dev-util/shadowman
"

PATCHES=( "${FILESDIR}/${P}-libcap-ng.patch" )

src_configure() {
	local myeconfargs=(
		--enable-shared --disable-static
		--enable-clang-wrappers
		--enable-clang-rewrite-includes
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream-r2 icecream

	insinto /etc/logrotate.d
	newins suse/logrotate icecream

	insinto /usr/share/shadowman/tools
	newins - icecc <<<'/usr/libexec/icecc/bin'

	find "${D}" -name '*.la' -delete || die
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
		eselect compiler-shadow remove icecc
	fi
}

pkg_postinst() {
	if [[ ${ROOT} == / ]]; then
		eselect compiler-shadow update icecc
	fi
}
