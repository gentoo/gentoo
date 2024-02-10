# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE="xml(+)"

inherit python-any-r1 systemd

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang"
HOMEPAGE="https://www.rabbitmq.com/"
SRC_URI="https://github.com/rabbitmq/rabbitmq-server/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

# See https://www.rabbitmq.com/which-erlang.html for Erlang version
# See https://github.com/rabbitmq/rabbitmq-server/tree/main/deps/rabbitmq_cli#requirements for Elixir version
RDEPEND="
	acct-group/rabbitmq
	acct-user/rabbitmq
	>=dev-lang/erlang-25.0[ssl] <dev-lang/erlang-26.2
"
DEPEND="
	${RDEPEND}
	app-arch/zip
	app-arch/unzip
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	>=dev-lang/elixir-1.13.4 <dev-lang/elixir-1.16.0
	dev-libs/libxslt
	${PYTHON_DEPS}
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_compile() {
	emake all docs dist
}

src_install() {
	# erlang module
	local targetdir="/usr/$(get_libdir)/erlang/lib/rabbitmq_server-${PV}"

	einfo "Setting correct RABBITMQ_HOME in scripts"
	sed -e "s:^RABBITMQ_HOME=.*:RABBITMQ_HOME=\"${targetdir}\":g" \
		-i deps/rabbit/scripts/rabbitmq-env || die

	einfo "Installing Erlang modules to ${targetdir}"
	insinto "${targetdir}"
	doins -r deps/rabbit/ebin deps/rabbit/include deps/rabbit/priv escript plugins

	einfo "Installing server scripts to /usr/sbin"
	rm -v deps/rabbit/scripts/*.bat || die
	exeinto /usr/libexec/rabbitmq
	for script in deps/rabbit/scripts/*; do
		doexe ${script}
		newsbin "${FILESDIR}"/rabbitmq-script-wrapper $(basename $script)
	done

	# install the init script
	newinitd "${FILESDIR}"/rabbitmq-server.init-r4 rabbitmq
	systemd_dounit "${FILESDIR}/rabbitmq.service"

	# install documentation
	dodoc deps/rabbit/docs/*.example
	dodoc deps/rabbit/README.md
	doman deps/rabbit/docs/*.5
	doman deps/rabbit/docs/*.8

	# create the directory where our log file will go.
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/log/rabbitmq /etc/rabbitmq

	# create the mnesia directory
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/lib/rabbitmq/mnesia
}

pkg_preinst() {
	if [[ -n ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 3.12; then
		elog "Upgrading to RabbitMQ 3.12 requires all feature flags"
		elog "from 3.11 to be enabled. If any feature flags are not"
		elog "enabled, the node will refuse to start."
	fi
}
