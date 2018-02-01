# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 systemd user

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang"
HOMEPAGE="http://www.rabbitmq.com/"
SRC_URI="https://github.com/rabbitmq/rabbitmq-server/releases/download/v${PV}/rabbitmq-server-${PV}.tar.xz"

LICENSE="GPL-2 MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-lang/erlang-19.3[ssl]"
DEPEND="${RDEPEND}
	app-arch/zip
	app-arch/unzip
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	<dev-lang/elixir-1.6.0
	dev-libs/libxslt
	$(python_gen_any_dep 'dev-python/simplejson[${PYTHON_USEDEP}]')
"

pkg_setup() {
	enewgroup rabbitmq
	enewuser rabbitmq -1 -1 /var/lib/rabbitmq rabbitmq
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
	doins -r deps/rabbit/ebin deps/rabbit/escript deps/rabbit/include deps/rabbit/priv plugins

	einfo "Installing server scripts to /usr/sbin"
	rm -v deps/rabbit/scripts/*.bat
	exeinto /usr/libexec/rabbitmq
	for script in deps/rabbit/scripts/*; do
		doexe ${script}
		newsbin "${FILESDIR}"/rabbitmq-script-wrapper $(basename $script)
	done

	# install the init script
	newinitd "${FILESDIR}"/rabbitmq-server.init-r3 rabbitmq
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
	dodir /var/lib/rabbitmq{,/mnesia}
}

pkg_preinst() {
	if has_version "<=net-misc/rabbitmq-server-1.8.0"; then
		elog "IMPORTANT UPGRADE NOTICE:"
		elog
		elog "RabbitMQ is now running as an unprivileged user instead of root."
		elog "Therefore you need to fix the permissions for RabbitMQs Mnesia database."
		elog "Please run the following commands as root:"
		elog
		elog "  usermod -d /var/lib/rabbitmq rabbitmq"
		elog "  chown rabbitmq:rabbitmq -R /var/lib/rabbitmq"
		elog
	elif has_version "<net-misc/rabbitmq-server-2.1.1"; then
		elog "IMPORTANT UPGRADE NOTICE:"
		elog
		elog "Please read release notes before upgrading:"
		elog
		elog "http://www.rabbitmq.com/release-notes/README-3.0.0.txt"
	fi
	if has_version "<net-misc/rabbitmq-server-3.3.0"; then
		elog
		elog "This release changes the behaviour of the default guest user:"
		elog
		elog "http://www.rabbitmq.com/access-control.html"
	fi
}
