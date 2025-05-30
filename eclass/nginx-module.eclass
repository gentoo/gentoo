# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# Jonas Licht <jonas.licht@gmail.com>
# @AUTHOR:
# Jonas Licht <jonas.licht@gmail.com>
# @BLURB: Provide a set of functions to build nginx dynamic modules.
# @DESCRIPTION:
# Eclass to make dynamic nginx modules.
# As these modules are built against one particular nginx version.
# The nginx version is encoded in PV as the first three version components,
# while the rest of PV represent's the module's upstream version.
#
# To build an nginx module the whole nginx source code is needed.
# Therefore SRC_URI is set to the nginx source archive.
# Ebuilds using this eclass thus must use SRC_URI+= instead of
# SRC_URI=.

case ${EAPI:-0} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit toolchain-funcs

# @ECLASS_VARIABLE: NGINX_PV
# @PRE_INHERIT
# @DESCRIPTION:
# Version of www-apps/nginx to build against.
# Default is the first three components of PV.
: "${NGINX_PV:=$(ver_cut 1-3)}"

# @ECLASS_VARIABLE: MODULE_PV
# @PRE_INHERIT
# @DESCRIPTION:
# Module version minus the www-apps/nginx version.
# Default is all components of PV starting with the 4th component.
: "${MODULE_PV=$(ver_cut 4-)}"

# @ECLASS_VARIABLE: MODULE_SOURCE
# @DESCRIPTION:
# Path to the unpacked source directory of the module.
# Defaults to '${WORKDIR}/${PN}-${MODULE_PV}', mimicking the default value of S.
: "${MODULE_SOURCE:="${WORKDIR}/${PN}-${MODULE_PV}"}"

BDEPEND="~www-servers/nginx-${NGINX_PV}:="
SRC_URI="https://nginx.org/download/nginx-${NGINX_PV}.tar.gz"

S="${WORKDIR}/nginx-${NGINX_PV}"

EXPORT_FUNCTIONS src_configure src_compile src_install

# @FUNCTION: nginx-module_src_configure
# @USAGE: [additional-args]
# @DESCRIPTION:
# Parses the configure from the original nginx binary by executing 'nginx -V' and
# adds the package as dynamic module.
nginx-module_src_configure() {
	if [ "$(grep -c "\.[[:space:]]auto/module" "${MODULE_SOURCE}/config")" -eq 0 ]; then
		die "module uses old unsupported static config file syntax: https://www.nginx.com/resources/wiki/extending/converting/"
	fi
	#grep nginx configure from nginx -V add drop all other external modules
	NGINX_ORIGIN_CONFIGURE=$(nginx -V 2>&1 | grep "configure arguments:" | cut -d: -f2 | sed "s/--add-module=\([^\s]\)*\s/ /")
	# shellcheck disable=SC2086
	./configure ${NGINX_ORIGIN_CONFIGURE} --add-dynamic-module="${MODULE_SOURCE}" "$@" || die "configure failed"
}

# @FUNCTION: nginx-module_src_compile
# @USAGE: [additional-args]
# @DESCRIPTION:
# Runs 'make modules' to only build our package module.
nginx-module_src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake modules "$@" CC="$(tc-getCC)" LINK="$(tc-getCC) ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

# @FUNCTION: nginx-module_src_install
# @DESCRIPTION:
# Parses the module config file to get the shared object file name and install the file to the nginx module directory.
nginx-module_src_install() {
	einstalldocs

	local NGINX_MODULE_NAME
	NGINX_MODULE_NAME=$(grep "${MODULE_SOURCE}/config" -e "ngx_addon_name" | cut -d= -f2)
	exeinto /usr/$(get_libdir)/nginx/modules
	doexe objs/${NGINX_MODULE_NAME}.so
}
