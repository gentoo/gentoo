# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-auth-ldap"
MY_COMMIT="241200eac8e4acae74d353291bd27f79e5ca3dc4"

inherit nginx-module

DESCRIPTION="LDAP authentication module for NGINX"
HOMEPAGE="https://github.com/kvspb/nginx-auth-ldap"
SRC_URI="
	https://github.com/kvspb/nginx-auth-ldap/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND="net-nds/openldap"
RDEPEND="${DEPEND}"
