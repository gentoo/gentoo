# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem user

DESCRIPTION="data collector and unified logging layer (project under CNCF)"
HOMEPAGE="https://www.fluentd.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/msgpack-0.7.0
	>=dev-ruby/yajl-ruby-1.0
	>=dev-ruby/coolio-1.4.5
	>=dev-ruby/serverengine-2.0.4
	>=dev-ruby/http_parser_rb-0.5.1
	>=dev-ruby/sigdump-0.2.2
	>=dev-ruby/tzinfo-1.0
	>=dev-ruby/strptime-0.2.2"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

all_ruby_prepare() {
	sed -i \
		-e '/tzinfo-data/d' \
		-e '/dig_rb/d' \
		"${PN}".gemspec || die "'sed failed"

	# Avoid test dependency on unpackaged oj
	rm -f test/test_event_time.rb || die
}

all_ruby_install() {
	all_fakegem_install
	keepdir /var/log/fluentd
	fowners fluentd:adm /var/log/fluentd
	insinto /etc/fluent
	doins fluent.conf
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "A default configuration file has been installed in"
		elog "${EROOT}etc/fluent/fluent.conf. You will need to edit"
		elog "this file to match your configuration."
	fi
}
