# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"

inherit python-single-r1 systemd

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang"
HOMEPAGE="https://www.rabbitmq.com/"
SRC_URI="https://github.com/rabbitmq/rabbitmq-server/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

ACCT_DEPEND="
	acct-group/rabbitmq
	acct-user/rabbitmq
"
# See https://www.rabbitmq.com/which-erlang.html for Erlang version
ERLANG_DEPEND="
	>=dev-lang/erlang-26.0[ssl] <dev-lang/erlang-28
"
RDEPEND="
	${ACCT_DEPEND}
	${ERLANG_DEPEND}
	${PYTHON_DEPS}
"
# See https://github.com/rabbitmq/rabbitmq-server/blob/main/deps/rabbitmq_cli/mix.exs for Elixir version
DEPEND="
	${ERLANG_DEPEND}
	app-arch/zip
	app-arch/unzip
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	>=dev-lang/elixir-1.13.4 <dev-lang/elixir-1.20.0
	dev-libs/libxslt
"
BDEPEND="
	${ACCT_DEPEND}
	${ERLANG_DEPEND}
	sys-apps/which
	|| (
		app-arch/7zip
		app-arch/p7zip
	)
"

src_compile() {
	python_fix_shebang deps/rabbitmq_management/bin/rabbitmqadmin

	# Disable parallel make
	# https://bugs.gentoo.org/930093
	# https://bugs.gentoo.org/930098
	# https://bugs.gentoo.org/930133
	emake -j1 PROJECT_VERSION=${PV} all docs dist
}

src_install() {
	# erlang module
	local targetdir="/usr/$(get_libdir)/erlang/lib/rabbitmq_server-${PV}"

	einfo "Setting correct RABBITMQ_HOME in scripts"
	sed -e "s:^RABBITMQ_HOME=.*:RABBITMQ_HOME=\"${targetdir}\":g" \
		-i deps/rabbit/scripts/rabbitmq-env || die

	einfo "Installing Erlang modules to ${targetdir}"
	insinto "${targetdir}"
	chmod +x escript/* || die
	insopts -m0755
	doins -r deps/rabbit/ebin deps/rabbit/include deps/rabbit/priv escript plugins

	einfo "Installing server scripts to /usr/sbin"
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
