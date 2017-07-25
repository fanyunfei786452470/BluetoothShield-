/*
	GLOBAL.H - RSAEURO types and constants

	Copyright (c) J.S.A.Kapp 1994 - 1995.

	RSAEURO - RSA Library compatible with RSAREF(tm) 2.0.

	All functions prototypes are the Same as for RSAREF(tm).
	To aid compatiblity the source and the files follow the
	same naming comventions that RSAREF(tm) uses.  This should aid
	direct importing to your applications.

	This library is legal everywhere outside the US.  And should
	NOT be imported to the US and used there.

	All Trademarks Acknowledged.

	Global types and contants file.

	Revision 1.00 - JSAK 23/6/95, Final Release Version
*/

#ifndef _GLOBAL_H_
#define _GLOBAL_H_

/* PROTOTYPES should be set to one if and only if the compiler supports
		 function argument prototyping.
	 The following makes PROTOTYPES default to 1 if it has not already been
		 defined as 0 with C compiler flags. */

typedef enum
{
    ApiTypeQueryToken = 1 ,             //获取密码器信息
    
    ApiTypeUpdatePin = 3,               //修改PIN码
    
    ApiTypeActiveTokenPlug,             //激活密码器
    
    ApiTypeUnlockRandomNo,              //获取解锁码
    
    ApiTypeUnlockPin,                   //密码器解锁
    
    ApiTypeLcdOpCode = 9,               //LCD显示控制
    
    ApiTypeShowHxTransferInfo,          //汉显GBK
    
    ApiTypeGetTokenCodeSafety = 12,     //获取动态密码
    
    ApiTypeQueryTokenEX = 14,           //获取密码器序列号
    
    ApiTypeQueryVersionHW,              //获取密码器型号
    
    ApiTypeRecordInfo,                  //插入交易信息
    
    ApiTypeQueryInfo,                   //查询交易信息
    
    ApiTypeCancelTrans = 18,                //取消转账功能，或者清屏
    
    ApiTypeShowWallet,                      //显示钱包充值金额
    
    ApiTypeDelayLcd,                        //设置屏背光亮的时间
    
    ApiTypeGetTokenCodeSafety_key,          //新增接口,用户转账时获取动态密码,需要按键确定
    
    ApiTypeScanCode,                        //新增接口,扫码支付 获取动态密码,需要按键确定
    
    ApiTypeFinallyTrans,
    
    ApiTypePowerShow = 101              //显示密码电量
    
}ApiType;

#ifndef PROTOTYPES
#define PROTOTYPES 1
#endif

#ifndef TRUE
#define TRUE            1
#endif
#ifndef FALSE
#define FALSE           0
#endif
#ifndef NULL
#define NULL            0
#endif
#ifndef VOID
typedef void            VOID;
#endif
#ifndef INT8
typedef char            INT8;
#endif
#ifndef UINT8
typedef unsigned char   UINT8;
#endif
#ifndef INT16
typedef short           INT16;
#endif
#ifndef UINT16
typedef unsigned short  UINT16;
#endif
#ifndef INT32
typedef int             INT32;
#endif
#ifndef UINT32
typedef unsigned int    UINT32;
#endif
#ifndef LONG
typedef long            LONG;
#endif
#ifndef ULONG
typedef unsigned long   ULONG;
#endif
#ifndef WIN32
#ifndef BOOL
//typedef UINT8           BOOL;
#endif
#endif
#ifndef CHAR
typedef INT8            CHAR;
#endif
#ifndef BYTE
typedef UINT8           BYTE;
#endif
#ifndef SHORT
typedef INT16           SHORT;
#endif
#ifndef USHORT
typedef UINT16          USHORT;
#endif
#ifndef INT
typedef INT32           INT;
#endif
#ifndef UINT
typedef UINT32          UINT;
#endif
#ifndef WORD
typedef UINT16          WORD;
#endif
#ifndef DWORD
typedef ULONG           DWORD;
#endif
#ifndef FLAGS
typedef UINT32          FLAGS;
#endif
#ifndef LPSTR
typedef CHAR *          LPSTR;
#endif
#ifndef HANDLE
typedef void *          HANDLE;
#endif

#ifndef HCONTAINER
typedef HANDLE          HCONTAINER;
#endif

#ifndef DEVHANDLE
typedef HANDLE          DEVHANDLE;
#endif

#ifndef HAPPLICATION
typedef HANDLE  HAPPLICATION;
#endif

#define STATUS_TIMEOUT              -1
#define STATUS_FAILED              0x0000
#define STATUS_SUCCESS             0x0001

typedef struct _tagAPPLICATION
{
    CHAR szName[48];
    WORD wAppID;
}
APPLICATION, *PAPPLICATION;

typedef struct _tagCONTAINER
{
    CHAR szName[48];
    WORD wContainerID;
}
CONTAINER, *PCONTAINER;

typedef int ( * CALLBACK_FUNC )( VOID * obj, VOID * cbf, VOID * param );

typedef struct _tagREADFILE
{
    WORD wAppID;
    WORD wOffset;
    WORD wFileNameLen;
    CHAR chFileName[40];
}
READFILE, *HREADFILE;

/* POINTER defines a generic pointer type */
typedef unsigned char *POINTER;

/* UINT2 defines a two byte word */
typedef unsigned short int UINT2;

/* UINT4 defines a four byte word */
typedef unsigned long int UINT4;

/* BYTE defines a unsigned character */
//typedef unsigned char BYTE;

/* internal signed value */
typedef signed long int signeddigit;

#ifndef NULL_PTR
#define NULL_PTR ((POINTER)0)
#endif

#ifndef UNUSED_ARG
#define UNUSED_ARG(x) x = *(&x);
#endif

/* PROTO_LIST is defined depending on how PROTOTYPES is defined above.
	 If using PROTOTYPES, then PROTO_LIST returns the list, otherwise it
	 returns an empty list. */

#if PROTOTYPES
#define PROTO_LIST(list) list
#else
#define PROTO_LIST(list) ()
#endif

#endif /* _GLOBAL_H_ */


#define STRART_FLAG 0x00
#define SYNC_FALG   0x02 //次字节后四位表示的是接收的波形个数

