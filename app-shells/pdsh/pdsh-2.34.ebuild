# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A high-performance, parallel remote shell utility"
HOMEPAGE="https://github.com/chaos/pdsh"
SRC_URI="https://github.com/chaos/pdsh/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt readline rsh test"
RESTRICT="!test? ( test )"

RDEPEND="
	crypt? ( net-misc/openssh )
	rsh? ( net-misc/netkit-rsh )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-util/dejagnu )"

PATCHES=(
	"${FILESDIR}/${PN}-2.34-slibtool.patch"
)

pkg_setup() {
	PDSH_MODULE_LIST="${PDSH_MODULE_LIST:-netgroup}"
	MODULE_CONFIG=""

	local m
	local valid_modules=":xcpu:ssh:exec:qshell:genders:nodeupdown:mrsh:mqshell:dshgroups:netgroup:"

	for m in ${PDSH_MODULE_LIST}; do
		if [[ "${valid_modules}" == *:${m}:* ]]; then
			MODULE_CONFIG="${MODULE_CONFIG} --with-${m}"
		fi
	done

	elog "Building ${PF} with the following modules:"
	elog "  ${PDSH_MODULE_LIST}"
	elog "This list can be changed in /etc/portage/make.conf by setting"
	elog "PDSH_MODULE_LIST=\"module1 module2...\""
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf ${MODULE_CONFIG} \
		--with-machines \
		--enable-shared \
		--disable-static \
		$(use_with crypt ssh) \
		$(use_with rsh) \
		$(use_with readline)
}
