# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake eapi9-ver systemd

DESCRIPTION="onak is an OpenPGP keyserver"
HOMEPAGE="
	https://www.earth.li/projectpurple/progs/onak.html
	https://github.com/u1f35c/onak
"
SRC_URI="https://github.com/u1f35c/onak/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+berkdb +daemon hkp postgres systemd"

RDEPEND="
	acct-group/onak
	acct-user/onak
	dev-libs/nettle:=
	dev-libs/gmp:=
	berkdb? ( sys-libs/db:= )
	daemon? (
		systemd? ( sys-apps/systemd:= )
	)
	hkp? ( net-misc/curl )
	postgres? ( dev-db/postgresql:= )
"
DEPEND="${RDEPEND}"

DOCS=(
	README.md onak.sql
)

PATCHES=(
	"${FILESDIR}/${PN}-0.5.0-musl-strtouq-fix.patch"
	"${FILESDIR}/${PN}-0.6.3-cmake.patch"
)

src_prepare() {
	cmake_src_prepare

	# use a subdir to handle permissions
	sed -e 's:log/onak.log:log/onak/onak.log:' \
		-i onak.ini.in || die
	sed -e "s:/var/log/onak.log:${EPREFIX}/var/log/onak/onak.log:" \
		-i debian/onak.logrotate || die

	if ! use systemd; then
		sed -e 's:^pkg_check_modules.*libsystemd:#&:' \
			-i CMakeLists.txt || die
	fi
}

src_configure() {
	# The GENTOO_BACKENDS variable is controlled from the ebuild, therefore
	# it can be synchronised with users USE preference, unlike the BACKENDS
	# which is filled automagically based on detected libraries.
	# Initialize backends with default values.
	local backends=( file fs keyring stacked )
	use berkdb && backends+=( db4 )
	use daemon && backends+=( keyd )
	use hkp && backends+=( hkp )
	use postgres && backends+=( pg )
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git="ON"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		# force shared libs backends or only one backend will be available.
		-DDBTYPE=dynamic
		-DGENTOO_BACKENDS=$(IFS=';'; echo "${backends[*]}")
		-DKEYD=$(usex daemon ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use daemon; then
		newinitd "${FILESDIR}"/onak.init onak
		systemd_dounit debian/onak.service
		systemd_dounit debian/onak.socket
	fi

	insinto /etc/logrotate.d
	newins debian/onak.logrotate onak

	keepdir /var/{lib,log}/${PN}
	fowners -R onak:onak /var/{lib,log}/${PN}

	insinto /usr/$(get_libdir)/cgi-bin/pks
	doins "${BUILD_DIR}"/cgi/{add,gpgwww,hashquery,lookup}

	docinto examples
	dodoc doc/{apache2,mathopd.conf}
}

pkg_postinst() {
	if ver_replacing -lt 0.6.4; then
		ewarn "The key daemon is now handled by the useflag 'daemon'."
		ewarn "This package provides the init scripts for both OpenRC and systemd."
		if use daemon; then
			ewarn " "
			ewarn "The binaries for the key daemon has been renamed:"
			ewarn "keyd -> onak-keyd"
			ewarn "keydctl -> onak-keydctl"
			ewarn "Consider adapt your scripts!"
		fi
		if [[ $(get_libdir) != "lib" ]]; then
			ewarn " "
			ewarn "The binaries for cgi has been moved:"
			ewarn "${EPREFIX}/usr/lib/cgi-bin/ -> ${EPREFIX}/usr/$(get_libdir)/cgi-bin/"
			ewarn "Consider adapt your scripts!"
		fi
	fi
}
