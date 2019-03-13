# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver user

DESCRIPTION="Set of scripts to manage google-auth setup on Gentoo Infra"
HOMEPAGE="https://github.com/mgorny/google-authenticator-wrappers"
SRC_URI="https://github.com/mgorny/google-authenticator-wrappers/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-auth/google-authenticator"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ver_test "${v}" -lt 3; then
				ewarn "google-authenticator-wrappers v3 switches the secret store mechanism"
				ewarn "from user-owned files to /var/lib/gauth.  To migrate secrets, move"
				ewarn "and chown, e.g.:"
				ewarn
				ewarn "  mv /home/myuser/.google_authenticator /var/lib/gauth/myuser"
				ewarn "  chown gauth /var/lib/gauth/myuser"
				ewarn
				ewarn "If you do not migrate or reset secrets, second step authentication"
				ewarn "will be disabled after the upgrade."
				break
			fi
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DGAUTH_USERNAME=gauth
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	enewgroup gauth
	enewuser gauth -1 -1 -1 gauth
	fowners gauth:gauth /var/lib/gauth /usr/bin/gauthctl /usr/bin/gauth-test
	fperms ug+s /usr/bin/gauthctl /usr/bin/gauth-test
}
