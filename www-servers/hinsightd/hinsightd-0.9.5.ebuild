# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit fcaps lua-single systemd cmake linux-info

DESCRIPTION="hinsightd a http/1.1 webserver with (hopefully) minimal goals"
HOMEPAGE="https://gitlab.com/tiotags/hin9"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/tiotags/hin9.git"
else
	SRC_URI="https://gitlab.com/tiotags/hin9/-/archive/v${PV}/hin9-v${PV}.tar.gz"
	S="${WORKDIR}/hin9-v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

IUSE="+openssl"
REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"

RDEPEND="
	${LUA_DEPS}
	acct-user/hinsightd
	acct-group/hinsightd
	sys-libs/liburing
	sys-libs/zlib
	openssl? ( dev-libs/openssl )
"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/hinsightd-defines-v3.patch"
)

src_configure() {
	local mycmakeargs=(
		-DUSE_OPENSSL=$(usex openssl)
	)
	cmake_src_configure
}

src_install() {
	newsbin "${BUILD_DIR}/hin9" $PN
	newinitd "${FILESDIR}/initd-v1.sh" $PN
	systemd_dounit "${FILESDIR}/$PN.service" # not tested

	# config
	insinto /etc/$PN
	doins "${S}/workdir/main.lua"
	doins "${S}/workdir/lib.lua"
	doins "${S}/workdir/default_config.lua"

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate.d.sh $PN

	keepdir /var/www/localhost/htdocs
}

pkg_postinst() {
	fcaps CAP_NET_BIND_SERVICE /usr/sbin/$PN

	if kernel_is lt 5 7; then
		ewarn ""
		ewarn "hinsightd requires io_uring and kernel ~5.6.0"
		ewarn ""
	fi

	ewarn ""
	ewarn "hinsightd requires a higher than default RLIMIT_MEMLOCK for"
	ewarn "things like graceful restarting"
	ewarn "memory limit can be increased in /etc/security/limits.conf"
	ewarn ""
}
