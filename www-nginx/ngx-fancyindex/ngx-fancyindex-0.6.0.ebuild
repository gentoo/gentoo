# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo nginx-module

DESCRIPTION="Fancy indexes module for the NGINX web server"
HOMEPAGE="https://github.com/aperezdc/ngx-fancyindex"
SRC_URI="
	https://github.com/aperezdc/ngx-fancyindex/releases/download/v${PV}/${P}.tar.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		net-misc/wget
		sys-apps/iproute2
	)
"

src_test() {
	local prefix="${T}/prefix"
	mkdir -p "${prefix}"/{conf,logs,modules,sbin,tmp} || die

	ln -s "${WORKDIR}/nginx/build/${NGINX_MOD_SHARED_OBJECTS[0]}" \
		"${prefix}/modules/" || die
	echo 'types { text/html html; }' > "${prefix}/conf/mime.types" || die

	cat > "${prefix}/sbin/nginx" <<-EOF || die
		#!/bin/sh
		exec "${BROOT}/usr/sbin/nginx" -p "${prefix}" \\
			-c "${prefix}/conf/nginx.conf" -e "${prefix}/logs/error.log" \\
			-g "pid ${prefix}/logs/nginx.pid;" "\$@"
	EOF
	chmod +x "${prefix}/sbin/nginx" || die

	local tmp ngx_flags conf="access_log ${prefix}/logs/access.log;"
	ngx_flags=$("${BROOT}/usr/sbin/nginx" -V 2>&1) || die
	for tmp in client_body proxy fastcgi uwsgi scgi; do
		[[ ${ngx_flags} == *--without-http_${tmp}_module* ]] && continue
		conf+=" ${tmp}_temp_path ${prefix}/tmp/${tmp};"
	done
	sed -i "/default_type/a ${conf}" t/preamble || die

	edo ./t/run "${prefix}" 1
}
