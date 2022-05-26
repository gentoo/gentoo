# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MSTEMLE"

inherit perl-module

DESCRIPTION="interact with RabbitMQ over AMQP using librabbitmq"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Math-Int64-0.540.0"

BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.660.0
	test? (
		net-misc/rabbitmq-server
	)
"

src_test() {
	einfo "Starting rabbitmq"
	local -x RABBITMQ_LOG_BASE="${T}/rabbitmq/log"
	local -x RABBITMQ_MNESIA_BASE="${T}/rabbitmq/mnesia"
	local -x RABBITMQ_LOGS="${T}/rabbitmq.log"
	local -x RABBITMQ_PID_FILE="${T}/rabbitmq.pid"
	local -x RABBITMQ_ENABLED_PLUGINS_FILE="${T}/rabbitmq/enabled_plugins"
	/usr/libexec/rabbitmq/rabbitmq-server -p 5672:5672 &

	einfo "Waiting for rabbitmq to fully load"
	while ! { echo >/dev/tcp/localhost/5672 ; } &> /dev/null; do
		sleep 1
	done
	einfo "rabbitmq is ready"

	perl-module_src_test

	einfo "Stopping rabbitmq"
	kill "$(<"${RABBITMQ_PID_FILE}")" || die
}
