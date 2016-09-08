# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit python-utils-r1 systemd user

DESCRIPTION="The open-source database for the realtime web."
HOMEPAGE="http://www.rethinkdb.com"
LICENSE="AGPL-3"
SLOT="0"
SRC_URI="http://download.rethinkdb.com/dist/${P}.tgz"

KEYWORDS="~amd64 ~x86"
IUSE="doc +jemalloc tcmalloc"

# TODO: rly need some webui libs ?
DEPEND="dev-cpp/gtest
		dev-libs/boost
		dev-libs/protobuf-c
		>=dev-libs/re2-0.2016.05.01
		sys-libs/libunwind
		sys-libs/ncurses:=
		jemalloc? ( >=dev-libs/jemalloc-4.0 )
		tcmalloc? ( dev-util/google-perftools )"
RDEPEND="${DEPEND}"
REQUIRED_USE="?? ( tcmalloc jemalloc )"

pkg_setup() {
	enewgroup rethinkdb
	enewuser rethinkdb -1 -1 /var/lib/${PN} rethinkdb
}

src_prepare() {
	eapply_user

	# don't use predefined configuration
	rm configure.default

	# fix doc and init script auto installation
	sed -e 's/ install-docs / /g' -e 's/ install-init / /g' -i mk/install.mk || die

	# default config for Gentoo
	# fix default pid-file path
	# fix default directory path
	# fix default log-file path
	sed -e 's@/var/run/@/run/@g' \
		-e 's@/var/lib/rethinkdb/@/var/lib/rethinkdb/instances.d/@g' \
		-e 's@/var/log/rethinkdb@/var/log/rethinkdb/default.log@g' \
		-i packaging/assets/config/default.conf.sample || die

	# proper CXX declaration
	sed -e "s/CXX=\$(.*/CXX=$(tc-getCXX)/g" -i configure || die

	# respect user CXXFLAGS optimizations
	sed -e 's/-O3//g' -i src/build.mk || die
}

src_configure() {
	local conf_opts=(
		--prefix="/usr"
		--sysconfdir="/etc"
		--localstatedir="/var"
		--static=none
		--dynamic=gtest
		--dynamic=re2
	)
	if use jemalloc; then
		conf_opts+=(--with-jemalloc)
	elif use tcmalloc; then
		conf_opts+=(--with-tcmalloc)
	else
		conf_opts+=(--with-system-malloc)
	fi
	./configure "${conf_opts[@]}"
}

src_compile() {
	python_export python2.7 EPYTHON
	emake VERBOSE=1
}

src_install() {
	emake DESTDIR="${D}" VERBOSE=1 install

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners rethinkdb:rethinkdb "${x}"
	done

	newconfd "${FILESDIR}/rethinkdb.confd" rethinkdb
	newinitd "${FILESDIR}/rethinkdb.initd" rethinkdb

	systemd_newunit "${FILESDIR}/"${PN}.service "rethinkdb@.service"
	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfilesd "rethinkdb.conf"

	use doc && dodoc COPYRIGHT NOTES.md README.md
}

pkg_config() {
	einfo "This will prepare a new RethinkDB instance. Press Control-C to abort."

	einfo "Enter the name for the new instance: "
	read instance_name
	[[ -z "${instance_name}" ]] && die "Invalid instance name"

	local instance_data="/var/lib/rethinkdb/instances.d/${instance_name}"
	local instance_config="/etc/rethinkdb/instances.d/${instance_name}.conf"
	if [[ -e "${instance_data}" || -e "${instance_config}" ]]; then
		eerror "An instance with the same name already exists:"
		eerror "Check ${instance_data} or ${instance_config}."
		die "Instance already exists"
	fi

	/usr/bin/rethinkdb create -d "${instance_data}" &>/dev/null \
		|| die "Creating instance failed"
	chown -R rethinkdb:rethinkdb "${instance_data}" \
		|| die "Correcting permissions for instance failed"
	cp /etc/rethinkdb/default.conf.sample "${instance_config}" \
		|| die "Creating configuration file failed"
	sed -e "s:^# \(directory=\).*$:\1${instance_data}:" \
		-i "${instance_config}" \
		|| die "Modifying configuration file failed"
	ln -s /etc/init.d/rethinkdb "/etc/init.d/rethinkdb.${instance_name}" \
		|| die "Creating init script symlink failed"

	einfo "Successfully created the instance at ${instance_data}."
	einfo "To change the default settings edit the configuration file:"
	einfo "${instance_config}"
	einfo " "
	einfo "To start your instance, run:"
	einfo "/etc/init.d/rethinkdb.${instance_name}"
}
