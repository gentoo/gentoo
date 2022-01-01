# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for managing events and logs"
HOMEPAGE="https://www.elastic.co/products/logstash"
SRC_URI="x-pack? ( https://artifacts.elastic.co/downloads/${MY_PN}/${MY_P}-linux-x86_64.tar.gz )
	!x-pack? ( https://artifacts.elastic.co/downloads/${MY_PN}/${MY_PN}-oss-${PV}-linux-x86_64.tar.gz )"

# source: LICENSE.txt and NOTICE.txt
LICENSE="Apache-2.0 MIT x-pack? ( Elastic )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="x-pack"

RESTRICT="strip"
QA_PREBUILT="opt/logstash/vendor/jruby/lib/jni/*/libjffi*.so"

RDEPEND="acct-group/logstash
	acct-user/logstash
	virtual/jre"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	rm vendor/jruby/lib/jni/aarch64-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/arm-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/i386-SunOS/libjffi-1.2.so \
		vendor/jruby/lib/jni/mips64el-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/ppc64-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/ppc64le-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/sparcv9-Linux/libjffi-1.2.so \
		vendor/jruby/lib/jni/sparcv9-SunOS/libjffi-1.2.so \
		vendor/jruby/lib/jni/x86_64-DragonFlyBSD/libjffi-1.2.so \
		vendor/jruby/lib/jni/x86_64-FreeBSD/libjffi-1.2.so \
		vendor/jruby/lib/jni/x86_64-SunOS/libjffi-1.2.so || die
}

src_install() {
	keepdir /etc/"${MY_PN}"/{conf.d,patterns,plugins}
	keepdir "/var/log/${MY_PN}"

	insinto "/usr/share/${MY_PN}"
	newins "${FILESDIR}/agent.conf.sample" agent.conf

	rm -v config/{pipelines.yml,startup.options} || die
	insinto /etc/${MY_PN}
	doins -r config/.
	doins "${FILESDIR}/pipelines.yml"
	rm -rv config data || die

	insinto "/opt/${MY_PN}"
	doins -r .
	fperms 0755 "/opt/${MY_PN}/bin/${MY_PN}" "/opt/${MY_PN}/vendor/jruby/bin/jruby" "/opt/${MY_PN}/bin/logstash-plugin"

	newconfd "${FILESDIR}/${MY_PN}.confd-r2" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}.initd-r2" "${MY_PN}"

	insinto /usr/share/eselect/modules
	doins "${FILESDIR}"/logstash-plugin.eselect
}

pkg_postinst() {
	ewarn "Self installed plugins are removed during Logstash upgrades (Bug #622602)"
	ewarn "Install the plugins via eselect module that will automatically re-install"
	ewarn "all self installed plugins after Logstash upgrades."
	elog
	elog "Installing plugins:"
	elog "eselect logstash-plugin install logstash-output-gelf"
	elog

	elog "Reinstalling self installed plugins (installed via eselect module):"
	eselect logstash-plugin reinstall

	elog
	elog "Sample configuration:"
	elog "${EROOT}/usr/share/${MY_PN}"
	elog
	elog "The default pipeline configuration expects the configuration(s) to be found in:"
	elog "${EROOT}/etc/logstash/conf.d/*.conf"
}
