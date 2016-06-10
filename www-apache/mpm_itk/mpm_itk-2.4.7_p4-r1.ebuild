# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit apache-module linux-info

MY_PN=${PN/_/-}
MY_PV=${PV/_p/-0}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Run virtual hosts under separate users/groups"
HOMEPAGE="http://mpm-itk.sesse.net/"
SRC_URI="http://mpm-itk.sesse.net/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

# The libcap dependency is automagic, so we require it
# unconditionally. Reported upstream at,
#
# http://lists.err.no/pipermail/mpm-itk/2014-May/000808.html
#
#
# The -threads USE dependency is only reliable as long as we don't
# support building more than one MPM. See bug #511658.
#
DEPEND="sys-libs/libcap
	>=www-servers/apache-2.4.7[-threads]"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="00_${PN}"
APACHE2_MOD_DEFINE="MPM_ITK"
APXS2_ARGS="-c ${PN}.c seccomp.c -lcap"
need_apache2_4

pkg_setup() {
	CONFIG_CHECK="~SECCOMP"
	linux-info_pkg_setup

	local minkv="3.5"
	if kernel_is -lt ${minkv//./ }; then
		ewarn "A kernel newer than ${minkv} (with seccomp v2) is needed"
		ewarn "for LimitUIDRange and LimitGIDRange which we include by"
		ewarn "default in ${APACHE2_MOD_CONF}.conf."
	fi
}
