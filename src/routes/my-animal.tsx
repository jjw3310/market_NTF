import { Box, Button, Flex, Grid, Text } from "@chakra-ui/react";
import React, { FC, useEffect, useState } from "react";
import AnimalCard from "../components/AnimalCard";
import { mintAnimalTokenContract, saleAnimalTokenAddress } from "../web3Config";

interface MyAnimalProps {
    account: string;
}

const MyAnimal: FC<MyAnimalProps> = ({account}) => {
    const [animalCardArray, setAnimalCardArray] = useState<string[]>();
    const [saleStatus, setSaleStatus] = useState<boolean>(false); //판매상태를 가져와서 담을 변수

    const getAnimalTokens = async () => {
        try {
            const balanceLength = await mintAnimalTokenContract.methods.balanceOf(account).call(); // 밸런스 길이를 가져옴

            const tempAnimalCardArray = [];

        for(let i = 0; i < parseInt(balanceLength, 10); i++) {
            const animalTokenId = await mintAnimalTokenContract.methods.tokenOfOwnerByIndex(account, i).call(); // 토큰 아이디를 하나씩 가져옴 NFT 아이디를 가져옴

            const animalType = await mintAnimalTokenContract.methods.animalTypes(animalTokenId).call(); // 애니멀 타입을 알아내야 1~5번까지 중에 몇번 등록하는지 알 수 있음
            
            tempAnimalCardArray.push(animalType); // 푸쉬해서 애니멀 타입을 카드배열에 저장
        }

        setAnimalCardArray(tempAnimalCardArray); //최근거까지 푸쉬해놨던 것을 담아줌
        } catch (error) {
                console.error(error);
            }
        };
        const getIsApprovedForAll = async () => {
            try {
                const response = await mintAnimalTokenContract.methods.isApprovedForAll(account, saleAnimalTokenAddress).call();

                console.log(response);
            } catch (error) {
                console.error(error);
            }
        };

        useEffect(() => { // 1. 값이 없을 때 출력과
           if (!account) return;

           getIsApprovedForAll();
           getAnimalTokens();
        }, [account]); //주의사항은 어카운트가 처음에 안내려온다 인자가 없는데 실행한다고 하면 에러가 뜸.])

        // useEffect(() => { // 2. 값이 있을 때 출력
        //     console.log(animalCardArray);
        // }, [animalCardArray]);
    return (
        <>
        <Flex alignItems="center">
            <Text display="inline-bloc">Sale Status</Text>
            <Button size="xs" ml={2} colorScheme={"blue"}>Approve</Button>
        </Flex>
    <Grid templateColumns="repeat(5, 1fr)" gap={8}>
    {
        animalCardArray && animalCardArray.map((v, i) => { // 컴포넌트에 map 쓰면 키값을 줘야함
            return <AnimalCard key={i} animalType ={v} />;
        })
    }
    </Grid>
    </>
    );
};

export default MyAnimal;