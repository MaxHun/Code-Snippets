#!/bin/bash

keytool -genkey -keyalg RSA -alias Signer -keystore myKeystore -validity 18000
jar cfmv JBFM.jar MANIFEST.mk JBFM_Applet.class JBFM.class jbfm/* pics/*
jarsigner -keystore myKeystore -verbose JBFM.jar Signer
