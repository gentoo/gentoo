# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools eutils flag-o-matic multilib pam systemd toolchain-funcs

MY_PV=${PV/_/}
MY_P="${PN}-${MY_PV}"
PVER="20170822"

DESCRIPTION="The OpenAFS distributed file system"
HOMEPAGE="https://www.openafs.org/"
# We always d/l the doc tarball as man pages are not USE=doc material
[[ ${PV} == *_pre* ]] && MY_PRE="candidate/" || MY_PRE=""
SRC_URI="
	https://openafs.org/dl/openafs/${MY_PRE}${MY_PV}/${MY_P}-src.tar.bz2
	https://openafs.org/dl/openafs/${MY_PRE}${MY_PV}/${MY_P}-doc.tar.bz2
	https://dev.gentoo.org/~bircoph/afs/${PN}-patches-${PVER}.tar.xz
"

LICENSE="IBM BSD openafs-krb5-a APSL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="bitmap-later debug doc fuse kerberos +modules ncurses pam pthreaded-ubik +supergroups"

CDEPEND="
	virtual/libintl
	fuse? ( sys-fs/fuse:0= )
	kerberos? ( virtual/krb5 )
	ncurses? ( sys-libs/ncurses:0= )
	pam? ( sys-libs/pam )"

DEPEND="${CDEPEND}
	virtual/yacc
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)"

RDEPEND="${CDEPEND}
	modules? ( ~net-fs/openafs-kernel-${PV} )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${WORKDIR}/gentoo/patches" )

src_prepare() {
	default

	# fixing 2-nd level makefiles to honor flags
	sed -i -r 's/\<CFLAGS[[:space:]]*=/CFLAGS+=/; s/\<LDFLAGS[[:space:]]*=/LDFLAGS+=/' \
		src/*/Makefile.in || die '*/Makefile.in sed failed'

	# packaging is f-ed up, so we can't run eautoreconf
	# run autotools commands based on what is listed in regen.sh
	eaclocal -I src/cf
	eautoconf
	eautoconf -o configure-libafs configure-libafs.ac
	eautoheader
	einfo "Deleting autom4te.cache directory"
	rm -rf autom4te.cache
}

src_configure() {
	local myconf
	use debug && use pam && myconf="--enable-debug-pam"

	AFS_SYSKVERS=26 \
	econf \
		--disable-kernel-module \
		--disable-strip-binaries \
		$(use_enable bitmap-later) \
		$(use_enable debug) \
		$(use_enable debug debug-lwp) \
		$(use_enable fuse fuse-client) \
		$(use_enable ncurses gtx) \
		$(use_enable pam) \
		$(use_enable pthreaded-ubik) \
		$(use_enable supergroups) \
		$(use_with doc html-xsl /usr/share/sgml/docbook/xsl-stylesheets/html/chunk.xsl) \
		$(use_with kerberos krb5) \
		"${myconf}"
}

src_compile() {
	emake all_nolibafs
	local d
	if use doc; then
		for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
			emake -C "${d}" html;
		done
	fi
}

src_install() {
	local OPENRCDIR="${WORKDIR}/gentoo/openrc"
	local SYSTEMDDIR="${WORKDIR}/gentoo/systemd"

	emake DESTDIR="${ED}" install_nolibafs

	insinto /etc/openafs
	doins src/afsd/CellServDB
	echo "/afs:/var/cache/openafs:200000" > "${ED}"/etc/openafs/cacheinfo
	echo "openafs.org" > "${ED}"/etc/openafs/ThisCell

	# pam_afs and pam_afs.krb have been installed in irregular locations, fix
	if use pam ; then
		dopammod "${ED}"/usr/$(get_libdir)/pam_afs*
	fi
	rm -f "${ED}"/usr/$(get_libdir)/pam_afs* || die

	# remove kdump stuff provided by kexec-tools #222455
	rm -rf "${ED}"/usr/sbin/kdump*

	# avoid collision with mit_krb5's version of kpasswd
	mv "${ED}"/usr/bin/kpasswd{,_afs} || die
	mv "${ED}"/usr/share/man/man1/kpasswd{,_afs}.1 || die

	# move lwp stuff around #200674 #330061
	mv "${ED}"/usr/include/{lwp,lock,timer}.h "${ED}"/usr/include/afs/ || die
	mv "${ED}"/usr/$(get_libdir)/liblwp* "${ED}"/usr/$(get_libdir)/afs/ || die
	# update paths to the relocated lwp headers
	sed -ri \
		-e '/^#include <(lwp|lock|timer).h>/s:<([^>]*)>:<afs/\1>:' \
		"${ED}"/usr/include/*.h \
		"${ED}"/usr/include/*/*.h \
		|| die

	# minimal documentation
	use pam && doman src/pam/pam_afs.5
	DOCS=( "${WORKDIR}/gentoo/README.Gentoo"
			src/afsd/CellServDB NEWS README )

	# documentation package
	if use doc ; then
		DOCS+=( doc/{arch,examples,pdf,protocol,txt} )
		dohtml -r doc/xml/
	fi

	einstalldocs

	# Gentoo related scripts
	newinitd "${OPENRCDIR}"/openafs-client.initd openafs-client
	newconfd "${OPENRCDIR}"/openafs-client.confd openafs-client
	newinitd "${OPENRCDIR}"/openafs-server.initd openafs-server
	newconfd "${OPENRCDIR}"/openafs-server.confd openafs-server
	systemd_dotmpfilesd "${SYSTEMDDIR}"/tmpfiles.d/openafs-client.conf
	systemd_dounit "${SYSTEMDDIR}"/openafs-client.service
	systemd_dounit "${SYSTEMDDIR}"/openafs-server.service
	systemd_install_serviced "${SYSTEMDDIR}"/openafs-client.service.conf
	systemd_install_serviced "${SYSTEMDDIR}"/openafs-server.service.conf

	# used directories: client
	keepdir /etc/openafs

	# used directories: server
	keepdir /etc/openafs/server
	diropts -m0700
	keepdir /var/lib/openafs
	keepdir /var/lib/openafs/db
	diropts -m0755
	keepdir /var/lib/openafs/logs

	# link logfiles to /var/log
	dosym ../lib/openafs/logs /var/log/openafs
}

pkg_preinst() {
	## Somewhat intelligently install default configuration files
	## (when they are not present)
	local x
	for x in cacheinfo CellServDB ThisCell ; do
		if [ -e "${EROOT}"/etc/openafs/${x} ] ; then
			cp "${EROOT}"/etc/openafs/${x} "${ED}"/etc/openafs/
		fi
	done
}

pkg_postinst() {
	elog "This installation should work out of the box (at least the"
	elog "client part doing global afs-cell browsing, unless you had"
	elog "a previous and different configuration).  If you want to"
	elog "set up your own cell or modify the standard config,"
	elog "please have a look at the Gentoo OpenAFS documentation"
	elog "(warning: it is not yet up to date wrt the new file locations)"
	elog
	elog "The documentation can be found at:"
	elog "  https://wiki.gentoo.org/wiki/OpenAFS"
	elog
	elog "Systemd users should run emerge --config ${CATEGORY}/${PN} before"
	elog "first use and whenever ${EROOT}/etc/openafs/cacheinfo is edited."
}

pkg_config() {
	elog "Setting cache options for systemd."

	SERVICED_FILE="${EROOT}"/etc/systemd/system/openafs-client.service.d/00gentoo.conf
	[ ! -e "${SERVICED_FILE}" ] && die "Systemd service.d file ${SERVICED_FILE} not found."

	CACHESIZE=$(cut -d ':' -f 3 "${EROOT}"/etc/openafs/cacheinfo)
	[ -z ${CACHESIZE} ] && die "Failed to parse ${EROOT}/etc/openafs/cacheinfo."

	if [ ${CACHESIZE} -lt 131070 ]; then
		AFSD_CACHE_ARGS="-stat 300 -dcache 100 -daemons 2 -volumes 50"
	elif [ ${CACHESIZE} -lt 524288 ]; then
		AFSD_CACHE_ARGS="-stat 2000 -dcache 800 -daemons 3 -volumes 70"
	elif [ ${CACHESIZE} -lt 1048576 ]; then
		AFSD_CACHE_ARGS="-stat 2800 -dcache 2400 -daemons 5 -volumes 128"
	elif [ ${CACHESIZE} -lt 2209715 ]; then
		AFSD_CACHE_ARGS="-stat 3600 -dcache 3600 -daemons 5 -volumes 196 -files 50000"
	else
		AFSD_CACHE_ARGS="-stat 4000 -dcache 4000 -daemons 6 -volumes 256 -files 50000"
	fi

	# Replace existing env var if exists, else append line
	grep -q "^Environment=\"AFSD_CACHE_ARGS=" "${SERVICED_FILE}" && \
		sed -i "s/^Environment=\"AFSD_CACHE_ARGS=.*/Environment=\"AFSD_CACHE_ARGS=${AFSD_CACHE_ARGS}\"/" "${SERVICED_FILE}" || \
		sed -i "$ a\Environment=\"AFSD_CACHE_ARGS=${AFSD_CACHE_ARGS}\"" "${SERVICED_FILE}" || \
		die "Updating ${SERVICED_FILE} failed."
}
