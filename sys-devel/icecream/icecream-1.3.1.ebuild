# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd tmpfiles

DESCRIPTION='Distributed compiling of C(++) code across several machines; based on distcc'
HOMEPAGE='https://github.com/icecc/icecream'
SRC_URI="https://github.com/icecc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE='GPL-2'
SLOT='0'
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE='systemd'

DEPEND='
	acct-user/icecream
	acct-group/icecream
	sys-libs/libcap-ng
	app-text/docbook2X
	app-arch/zstd
'
RDEPEND="
	${DEPEND}
	dev-util/shadowman
	systemd? ( sys-apps/systemd )
"

AT_NOELIBTOOLIZE='yes'

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-clang-rewrite-includes \
		--enable-clang-wrappers \
		--disable-fast-install
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	if use systemd; then
		systemd_dounit "${FILESDIR}/iceccd.service"
		systemd_dounit "${FILESDIR}/icecc-scheduler.service"
	else
		newconfd suse/sysconfig.icecream icecream
		newinitd "${FILESDIR}/icecream.openrc" icecream
	fi

	keepdir /var/log/icecream
	fowners icecream:icecream /var/log/icecream
	fperms  0750 /var/log/icecream

	newtmpfiles "${FILESDIR}/icecream-tmpfiles.conf" icecream.conf

	insinto /etc/logrotate.d
	newins suse/logrotate icecream

	insinto /etc/firewalld/services
	doins suse/iceccd.xml
	doins suse/icecc-scheduler.xml

	insinto /usr/share/shadowman/tools
	newins - icecc <<<'/usr/libexec/icecc/bin'
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
		eselect compiler-shadow remove icecc
	fi
}

pkg_postinst() {
	tmpfiles_process icecream.conf

	if [[ ${ROOT} == / ]]; then
		eselect compiler-shadow update icecc
	fi
}
