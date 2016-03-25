# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
SCONS_MIN_VERSION="1.2.0"
CHECKREQS_DISK_BUILD="2400M"
CHECKREQS_DISK_USR="512M"
CHECKREQS_MEMORY="1024M"

inherit eutils flag-o-matic multilib pax-utils scons-utils systemd user versionator check-reqs

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz
	mms-agent? ( https://dev.gentoo.org/~ultrabug/20140409-mms-monitoring-agent.zip )"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug kerberos mms-agent ssl static-libs"

PDEPEND="mms-agent? ( dev-python/pymongo app-arch/unzip )"
RDEPEND="
	app-arch/snappy
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.37[cxx]
	dev-libs/snowball-stemmer
	dev-util/google-perftools[-minimal]
	net-libs/libpcap
	ssl? ( >=dev-libs/openssl-1.0.1g )"
DEPEND="${RDEPEND}
	sys-libs/ncurses
	sys-libs/readline
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	scons_opts="--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX)"
	scons_opts+=" --disable-warnings-as-errors"
	scons_opts+=" --use-system-boost"
	scons_opts+=" --use-system-pcre"
	scons_opts+=" --use-system-snappy"
	scons_opts+=" --use-system-stemmer"
	scons_opts+=" --use-system-tcmalloc"
	scons_opts+=" --use-system-yaml"
	scons_opts+=" --usev8"

	if use debug; then
		scons_opts+=" --dbg=on"
	fi

	if use prefix; then
		scons_opts+=" --cpppath=${EPREFIX}/usr/include"
		scons_opts+=" --libpath=${EPREFIX}/usr/$(get_libdir)"
	fi

	if use kerberos; then
		scons_opts+=" --use-sasl-client"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.6.2-fix-scons.patch"
	epatch "${FILESDIR}/${PN}-2.4-fix-v8-pythonpath.patch"
	epatch "${FILESDIR}/${PN}-2.6.10-fix-boost-1.57.patch"

	# fix yaml-cpp detection
	sed -i -e "s/\[\"yaml\"\]/\[\"yaml-cpp\"\]/" SConstruct || die

	# bug #462606
	sed -i -e "s@\$INSTALL_DIR/lib@\$INSTALL_DIR/$(get_libdir)@g" src/SConscript.client || die

	# bug #482576
	sed -i -e "/-Werror/d" src/third_party/v8/SConscript || die
}

src_configure() {
	# filter some problematic flags
	filter-flags "-march=*"
	filter-flags -O?
}

src_compile() {
	escons ${scons_opts} all
}

src_install() {
	escons ${scons_opts} --full --nostrip install --prefix="${ED}"/usr

	use static-libs || find "${ED}"/usr/ -type f -name "*.a" -delete

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd-r2" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r2" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd-r2" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd-r2" ${PN/db/s}

	insinto /etc
	newins "${FILESDIR}/${PN}.conf-r2" ${PN}.conf
	newins "${FILESDIR}/${PN/db/s}.conf-r2" ${PN/db/s}.conf

	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# see bug #526114
	pax-mark emr "${ED}"/usr/bin/{mongo,mongod,mongos}

	if use mms-agent; then
		local MY_PN="mms-agent"
		local MY_D="/opt/${MY_PN}"

		insinto /etc
		newins "${WORKDIR}/${MY_PN}/settings.py" mms-agent.conf
		rm "${WORKDIR}/${MY_PN}/settings.py"

		insinto ${MY_D}
		doins "${WORKDIR}/${MY_PN}/"*
		dosym /etc/mms-agent.conf ${MY_D}/settings.py

		fowners -R mongodb:mongodb ${MY_D}
		newinitd "${FILESDIR}/${MY_PN}.initd-r2" ${MY_PN}
	fi
}

pkg_preinst() {
	# wrt bug #461466
	if [[ "$(get_libdir)" == "lib64" ]]; then
		rmdir "${ED}"/usr/lib/ &>/dev/null
	fi
}

src_test() {
	escons ${scons_opts} test
	"${S}"/test --dbpath=unittest || die
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 2.6 ]]; then
		ewarn "!! IMPORTANT !!"
		ewarn " "
		ewarn "${PN} configuration files have changed !"
		ewarn " "
		ewarn "Make sure you migrate from /etc/conf.d/${PN} to the new YAML standard in /etc/${PN}.conf"
		ewarn "  http://docs.mongodb.org/manual/reference/configuration-options/"
		ewarn " "
		ewarn "Make sure you also follow the upgrading process :"
		ewarn "  http://docs.mongodb.org/master/release-notes/2.6-upgrade/"
		ewarn " "
		if use mms-agent; then
			ewarn "MMS Agent configuration file has been moved to :"
			ewarn "  /etc/mms-agent.conf"
		fi
	else
		if use mms-agent; then
			elog "Edit your MMS Agent configuration file :"
			elog "  /etc/mms-agent.conf"
		fi
	fi
}
