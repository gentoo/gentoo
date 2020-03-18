# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-mod flag-o-matic pam systemd toolchain-funcs

MY_PV=${PV/_/}
MY_P="${PN}-${MY_PV}"
PVER=20190106
KERNEL_LIMIT=4.21

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

IUSE="api bitmap-later debug doc fuse kauth kerberos +modules +namei
ncurses perl +pthreaded-ubik +supergroups tsm ubik-read-while-write"

BDEPEND="
	dev-lang/perl
	sys-devel/flex
	virtual/yacc
	api? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	doc? (
		dev-libs/libxslt
		|| (
			dev-java/fop
			app-text/dblatex
			app-text/docbook-sgml-utils[jadetex]
		)
	)
	perl? ( dev-lang/swig )"
DEPEND="
	!net-fs/openafs-kernel
	virtual/libintl
	amd64? ( tsm? ( app-backup/tsm ) )
	doc? (
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.3
	)
	fuse? ( sys-fs/fuse:0= )
	kauth? ( sys-libs/pam )
	kerberos? ( virtual/krb5 )
	ncurses? ( sys-libs/ncurses:0= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${WORKDIR}/gentoo/patches" )

CONFIG_CHECK="~!AFS_FS KEYS"
ERROR_AFS_FS="OpenAFS conflicts with the in-kernel AFS-support. Make sure not to load both at the same time!"
ERROR_KEYS="OpenAFS needs CONFIG_KEYS option enabled"
MODULES_OPTIONAL_USE="modules"

QA_TEXTRELS_x86_fbsd="/boot/modules/libafs.ko"
QA_TEXTRELS_amd64_fbsd="/boot/modules/libafs.ko"

pkg_pretend() {
	if use modules && use kernel_linux && kernel_is -ge ${KERNEL_LIMIT/\./ } ; then
		ewarn "Gentoo supports kernels which are supported by OpenAFS"
		ewarn "which are limited to the kernel versions: < ${KERNEL_LIMIT}"
		ewarn ""
		ewarn "You are free to utilize epatch_user to provide whatever"
		ewarn "support you feel is appropriate, but will not receive"
		ewarn "support as a result of those changes."
		ewarn ""
		ewarn "Please do not file a bug report about this."
		ewarn ""
		ewarn "Alternatively, you may:"
		ewarn "1. Use OpenAFS FUSE client, build OpenAFS with USE=fuse to enable it."
		ewarn "2. Use native kernel AFS client: configure your kernel with CONFIG_AFS_FS."
		ewarn "net-fs/openafs is not required in this case, but client's functionality will be limited."
	fi
}

pkg_setup() {
	use kernel_linux && linux-mod_pkg_setup
}

src_prepare() {
	default

	# fixing 2-nd level makefiles to honor flags
	sed -i -r 's/\<CFLAGS[[:space:]]*=/CFLAGS+=/; s/\<LDFLAGS[[:space:]]*=/LDFLAGS+=/' \
		src/*/Makefile.in || die '*/Makefile.in sed failed'
	# fix xml docs to use local dtd files
	sed -i 's|http://www.oasis-open.org/docbook/xml/4.3|/usr/share/sgml/docbook/xml-dtd-4.3|' \
		doc/xml/*/*000.xml || die

	# packaging is f-ed up, so we can't run eautoreconf
	# run autotools commands based on what is listed in regen.sh
	eaclocal -I src/cf -I src/external/rra-c-util/m4
	eautoconf
	eautoconf -o configure-libafs configure-libafs.ac
	eautoheader
	einfo "Deleting autom4te.cache directory"
	rm -rf autom4te.cache || die
}

src_configure() {
	local -a myconf

	if use debug; then
		use kauth && myconf+=( --enable-debug-pam )
		use modules && myconf+=( --enable-debug-kernel )
	fi

	if use modules; then
		if use kernel_linux; then
			if kernel_is -ge 3 17 && kernel_is -le 3 17 2; then
				myconf+=( --enable-linux-d_splice_alias-extra-iput )
			fi
			myconf+=( --with-linux-kernel-headers="${KV_DIR}" \
					  --with-linux-kernel-build="${KV_OUT_DIR}" )
		elif use kernel_FreeBSD; then
			myconf+=( --with-bsd-kernel-build="${BSD_BUILD_DIR}" )
		fi
	fi

	use amd64 && use tsm && myconf+=( --enable-tivoli-tsm )

	local ARCH="$(tc-arch-kernel)"
	local MY_ARCH="$(tc-arch)"
	local BSD_BUILD_DIR="/usr/src/sys/${MY_ARCH}/compile/GENERIC"

	AFS_SYSKVERS=26 \
	econf \
		--disable-strip-binaries \
		$(use_enable bitmap-later) \
		$(use_enable debug) \
		$(use_enable debug debug-locks) \
		$(use_enable debug debug-lwp) \
		$(use_enable fuse fuse-client) \
		$(use_enable kauth) \
		$(use_enable modules kernel-module) \
		$(use_enable namei namei-fileserver) \
		$(use_enable ncurses gtx) \
		$(use_enable pthreaded-ubik) \
		$(use_enable supergroups) \
		$(use_enable ubik-read-while-write) \
		$(use_with api dot) \
		$(use_with doc docbook-stylesheets /usr/share/sgml/docbook/xsl-stylesheets) \
		$(use_with kerberos krb5) \
		$(use_with kerberos gssapi) \
		$(use_with perl swig) \
		"${myconf[@]}"
}

src_compile() {
	ARCH="$(tc-arch-kernel)" AR="$(tc-getAR)" emake V=1
	local d
	if use doc; then
		emake -C doc/xml/AdminGuide auagd000.pdf
		emake -C doc/xml/AdminRef auarf000.pdf
		emake -C doc/xml/QuickStartUnix auqbg000.pdf
		emake -C doc/xml/UserGuide auusg000.pdf
	fi
	use api && doxygen doc/doxygen/Doxyfile
}

src_install() {
	local OPENRCDIR="${WORKDIR}/gentoo/openrc"
	local SYSTEMDDIR="${WORKDIR}/gentoo/systemd"

	emake DESTDIR="${ED}" install_nolibafs

	if use modules; then
		if use kernel_linux; then
			local srcdir=$(expr "${S}"/src/libafs/MODLOAD-*)
			[[ -f ${srcdir}/libafs.${KV_OBJ} ]] || die "Couldn't find compiled kernel module"

			MODULE_NAMES="libafs(fs/openafs:${srcdir})"

			linux-mod_src_install
		elif use kernel_FreeBSD; then
			insinto /boot/modules
			doins "${S}"/src/libafs/MODLOAD/libafs.ko
		fi
	fi

	insinto /etc/openafs
	doins src/afsd/CellServDB
	echo "/afs:/var/cache/openafs:200000" > "${ED}"/etc/openafs/cacheinfo
	echo "openafs.org" > "${ED}"/etc/openafs/ThisCell

	# pam_afs and pam_afs.krb have been installed in irregular locations, fix
	if use kauth; then
		dopammod "${ED}"/usr/$(get_libdir)/pam_afs*
	fi
	rm -f "${ED}"/usr/$(get_libdir)/pam_afs* || die

	# remove kdump stuff provided by kexec-tools #222455
	rm -rf "${ED}"/usr/sbin/kdump* || die

	# avoid collision with mit_krb5's version of kpasswd
	if use kauth; then
		mv "${ED}"/usr/bin/kpasswd{,_afs} || die
		mv "${ED}"/usr/share/man/man1/kpasswd{,_afs}.1 || die
	fi

	# avoid collision with heimdal's pagsh
	if has_version app-crypt/heimdal; then
		mv "${ED}"/usr/bin/pagsh{,_afs} || die
		mv "${ED}"/usr/share/man/man1/pagsh{,_afs}.1 || die
	fi

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
	use kauth && doman src/pam/pam_afs.5
	DOCS=( "${WORKDIR}/gentoo/README.Gentoo"
			src/afsd/CellServDB NEWS README )

	# documentation package
	rm -rf doc/txt/winnotes || die # unneeded docs
	if use doc; then
		DOCS+=( doc/{pdf,protocol,txt} CODING CONTRIBUTING )
		newdoc doc/xml/AdminGuide/auagd000.pdf AdminGuide.pdf
		newdoc doc/xml/AdminRef/auarf000.pdf AdminRef.pdf
		newdoc doc/xml/QuickStartUnix/auqbg000.pdf QuickStartUnix.pdf
		newdoc doc/xml/UserGuide/auusg000.pdf UserGuide.pdf
	fi
	use api && DOCS+=( doc/doxygen/output/html )
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
	if use modules; then
		# Update linker.hints file
		use kernel_FreeBSD && /usr/sbin/kldxref "${EPREFIX}/boot/modules"
		use kernel_linux && linux-mod_pkg_postinst
	fi

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

pkg_postrm() {
	if use modules; then
		# Update linker.hints file
		use kernel_FreeBSD && /usr/sbin/kldxref "${EPREFIX}/boot/modules"
		use kernel_linux && linux-mod_pkg_postrm
	fi
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
